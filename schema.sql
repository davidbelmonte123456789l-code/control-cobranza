CREATE TABLE IF NOT EXISTS users (
 id SERIAL PRIMARY KEY, username TEXT UNIQUE NOT NULL, password_hash TEXT NOT NULL,
 display_name TEXT NOT NULL, role TEXT NOT NULL CHECK(role IN ('admin','supervisor','cobrador')),
 supervisor_id INTEGER REFERENCES users(id), active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS clients (
 id SERIAL PRIMARY KEY, name TEXT NOT NULL, phone TEXT, address TEXT, business TEXT, latitude NUMERIC(10,7), longitude NUMERIC(10,7), assigned_cobrador_id INTEGER REFERENCES users(id), created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS loans (
 id SERIAL PRIMARY KEY, client_id INTEGER NOT NULL REFERENCES clients(id), cobrador_id INTEGER REFERENCES users(id), amount NUMERIC(14,2) NOT NULL, interest NUMERIC(14,2) NOT NULL DEFAULT 0, total NUMERIC(14,2) NOT NULL, frequency TEXT NOT NULL CHECK(frequency IN ('Diaria','Semanal','Mensual')), installments_count INTEGER NOT NULL, installment_amount NUMERIC(14,2) NOT NULL, start_date DATE NOT NULL, status TEXT NOT NULL DEFAULT 'Activo', created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS installments (
 id SERIAL PRIMARY KEY, loan_id INTEGER NOT NULL REFERENCES loans(id) ON DELETE CASCADE, number INTEGER NOT NULL, due_date DATE NOT NULL, amount NUMERIC(14,2) NOT NULL, UNIQUE(loan_id,number)
);
CREATE TABLE IF NOT EXISTS payments (
 id SERIAL PRIMARY KEY, loan_id INTEGER NOT NULL REFERENCES loans(id), installment_id INTEGER REFERENCES installments(id), amount NUMERIC(14,2) NOT NULL CHECK(amount>0), paid_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), collector_id INTEGER REFERENCES users(id), note TEXT
);
CREATE TABLE IF NOT EXISTS expenses (
 id SERIAL PRIMARY KEY, amount NUMERIC(14,2) NOT NULL CHECK(amount>0), description TEXT NOT NULL, paid_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), collector_id INTEGER REFERENCES users(id), created_by INTEGER REFERENCES users(id)
);
CREATE TABLE IF NOT EXISTS cash_movements (
 id SERIAL PRIMARY KEY, user_id INTEGER NOT NULL REFERENCES users(id), type TEXT NOT NULL CHECK(type IN ('INYECCION','COBRO','GASTO','RETIRO','AJUSTE')), amount NUMERIC(14,2) NOT NULL CHECK(amount>0), payment_id INTEGER REFERENCES payments(id), expense_id INTEGER REFERENCES expenses(id), note TEXT, created_by INTEGER REFERENCES users(id), created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_log (
 id BIGSERIAL PRIMARY KEY, actor_id INTEGER REFERENCES users(id), action TEXT NOT NULL, entity TEXT, entity_id INTEGER, detail JSONB, created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_clients_cobrador ON clients(assigned_cobrador_id);
CREATE INDEX IF NOT EXISTS idx_loans_cobrador ON loans(cobrador_id);
CREATE INDEX IF NOT EXISTS idx_cash_user_date ON cash_movements(user_id,created_at);
CREATE INDEX IF NOT EXISTS idx_payments_loan ON payments(loan_id);
