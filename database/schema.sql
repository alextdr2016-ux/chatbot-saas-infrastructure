-- schema.sql - Schema multi-tenant pentru Ejolie Chatbot SaaS

-- ===========================================
-- EXTENSII
-- ===========================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- Pentru generare UUID
CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- Pentru gen_random_bytes

-- ===========================================
-- TABEL: tenants (clienții - magazinele)
-- ===========================================
CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,  -- ex: "ejolie", "fashion-store"
    domain VARCHAR(255),                 -- ex: "ejolie.ro"
    api_key VARCHAR(100) UNIQUE NOT NULL,
    
    -- Plan și billing
    plan VARCHAR(50) DEFAULT 'free',     -- free, starter, professional, enterprise
    messages_limit INT DEFAULT 100,       -- mesaje/lună permise
    messages_used INT DEFAULT 0,          -- mesaje folosite luna asta
    
    -- Configurări
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABEL: tenant_config (setări per tenant)
-- ===========================================
CREATE TABLE tenant_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    
    -- Branding
    bot_name VARCHAR(100) DEFAULT 'Asistent',
    welcome_message TEXT DEFAULT 'Bună! Cu ce te pot ajuta?',
    primary_color VARCHAR(7) DEFAULT '#007bff',
    
    -- Contact info
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    
    -- Logistics
    shipping_cost DECIMAL(10,2) DEFAULT 0,
    free_shipping_threshold DECIMAL(10,2) DEFAULT 200,
    return_policy TEXT,
    
    -- AI Settings
    ai_model VARCHAR(50) DEFAULT 'gpt-4o-mini',
    ai_temperature DECIMAL(2,1) DEFAULT 0.7,
    system_prompt TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(tenant_id)
);

-- ===========================================
-- TABEL: products (produsele fiecărui tenant)
-- ===========================================
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    
    external_id VARCHAR(100),            -- ID-ul din sistemul clientului
    name VARCHAR(500) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    sale_price DECIMAL(10,2),
    
    category VARCHAR(255),
    brand VARCHAR(255),
    
    stock INT DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    
    image_url TEXT,
    product_url TEXT,
    
    -- Pentru căutare semantică (vector embeddings)
    --embedding vector(1536),              -- OpenAI embedding dimension
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(tenant_id, external_id)
);

-- ===========================================
-- TABEL: conversations (sesiuni de chat)
-- ===========================================
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    
    session_id VARCHAR(255) NOT NULL,    -- ID sesiune din browser
    visitor_ip VARCHAR(45),              -- IPv4 sau IPv6
    visitor_country VARCHAR(2),          -- Cod țară
    
    status VARCHAR(50) DEFAULT 'active', -- active, closed, archived
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    
    -- Metadata
    user_agent TEXT,
    referrer TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABEL: messages (mesajele din conversații)
-- ===========================================
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    
    role VARCHAR(20) NOT NULL,           -- 'user' sau 'assistant'
    content TEXT NOT NULL,
    
    -- Tokens folosiți (pentru billing)
    tokens_input INT DEFAULT 0,
    tokens_output INT DEFAULT 0,
    
    -- Feedback
    rating INT,                          -- 1-5 stars
    feedback TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABEL: faq (întrebări frecvente per tenant)
-- ===========================================
CREATE TABLE faq (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100),
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- INDEXURI pentru performanță
-- ===========================================
CREATE INDEX idx_products_tenant ON products(tenant_id);
CREATE INDEX idx_products_name ON products(tenant_id, name);
CREATE INDEX idx_products_category ON products(tenant_id, category);
CREATE INDEX idx_products_active ON products(tenant_id, is_active);

CREATE INDEX idx_conversations_tenant ON conversations(tenant_id);
CREATE INDEX idx_conversations_session ON conversations(tenant_id, session_id);
CREATE INDEX idx_conversations_date ON conversations(tenant_id, created_at);

CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_tenant ON messages(tenant_id);
CREATE INDEX idx_messages_date ON messages(tenant_id, created_at);

CREATE INDEX idx_faq_tenant ON faq(tenant_id);

-- ===========================================
-- FUNCȚIE: Update timestamp automat
-- ===========================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers pentru updated_at
CREATE TRIGGER tenants_updated_at BEFORE UPDATE ON tenants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tenant_config_updated_at BEFORE UPDATE ON tenant_config
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER faq_updated_at BEFORE UPDATE ON faq
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ===========================================
-- DATE INIȚIALE: Tenant Ejolie (primul client)
-- ===========================================
INSERT INTO tenants (name, slug, domain, api_key, plan, messages_limit)
VALUES (
    'Ejolie',
    'ejolie', 
    'ejolie.ro',
    'ej_' || encode(gen_random_bytes(32), 'hex'),
    'professional',
    10000
);

-- Config pentru Ejolie
INSERT INTO tenant_config (tenant_id, bot_name, welcome_message, contact_email, contact_phone)
SELECT 
    id,
    'Levyn',
    'Bună! Sunt Levyn, asistentul virtual Ejolie. Cu ce te pot ajuta?',
    'contact@ejolie.ro',
    '0757 10 51 51'
FROM tenants WHERE slug = 'ejolie';