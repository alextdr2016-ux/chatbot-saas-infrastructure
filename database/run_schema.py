import psycopg2

# Conexiune la RDS
conn = psycopg2.connect(
    host="ejolie-chatbot-dev-db.cv4yeq4cmdyr.eu-central-1.rds.amazonaws.com",
    port=5432,
    database="ejolie_saas",
    user="ejolie_admin",
    password="SchimbaAcestaParola123!"  # Parola din terraform.tfvars
)

# Citește schema.sql
with open('schema.sql', 'r', encoding='utf-8') as f:
    schema = f.read()

# Execută schema
cursor = conn.cursor()
cursor.execute(schema)
conn.commit()

print("✅ Schema creată cu succes!")

# Verifică tabelele
cursor.execute(
    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
tables = cursor.fetchall()
print(f"\n📋 Tabele create: {[t[0] for t in tables]}")

cursor.close()
conn.close()
