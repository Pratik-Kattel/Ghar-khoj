import pool from "../config/db";
import bcrypt from "bcrypt";
import cuid from "cuid";

export const createAdminService = async (
  name: string,
  email: string,
  password: string,
  secretKey: string
) => {
  if (secretKey !== process.env.ADMIN_SECRET_KEY) {
    throw new Error("Invalid secret key");
  }

  const existing = await pool.query(
    "SELECT * FROM users WHERE email=$1",
    [email]
  );

  if (existing.rows.length > 0) {
    throw new Error("User already exists");
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const id = cuid();

  const res = await pool.query(
    `INSERT INTO users (user_id, name, email, password_hash, role, created_at)
     VALUES ($1, $2, $3, $4, 'ADMIN', NOW())
     RETURNING user_id, name, email, role`,
    [id, name, email, passwordHash]
  );

  return res.rows[0];
};