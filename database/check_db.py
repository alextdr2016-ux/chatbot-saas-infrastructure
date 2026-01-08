import psycopg2

conn = psycopg2.connect(
    host="ejolie-chatbot-dev-db.cv4yeq4cmdyr.eu-central-1.rds.amazonaws.com",
    port=5432,
    database="ejolie_saas",
    user="ejolie_admin",
    password="SchimbaAcestaParola123!"  # Parola ta reală
)

cursor = conn.cursor()

# Verifică tenant-ul Ejolie
cursor.execute("SELECT name, slug, api_key, plan FROM tenants")
tenant = cursor.fetchone()
print(f"🏪 Tenant: {tenant[0]} ({tenant[1]})")
print(f"🔑 API Key: {tenant[2]}")
print(f"📦 Plan: {tenant[3]}")

# Verifică config
cursor.execute("SELECT bot_name, welcome_message FROM tenant_config")
config = cursor.fetchone()
print(f"\n🤖 Bot: {config[0]}")
print(f"💬 Welcome: {config[1]}")

cursor.close()
conn.close()
