import pool from "../config/db";
import { sendEmail } from "../utils/mailer";


export const createLandlordRequestService = async (email: string, file: any) => {
 
  const userRes = await pool.query(
    "SELECT user_id, role, name FROM users WHERE email=$1",
    [email]
  );

  if (userRes.rows.length === 0) {
    throw new Error("User not found");
  }

  const user = userRes.rows[0];

  if (user.role === "LANDLORD") {
    throw new Error("Already a landlord");
  }

  
  const existing = await pool.query(
    "SELECT * FROM landlordrequests WHERE userId=$1",
    [user.user_id]
  );

  if (existing.rows.length > 0) {
    throw new Error("Request already submitted");
  }

  
  const requestRes = await pool.query(
    `INSERT INTO landlordrequests (id, userId, status, createdAt)
     VALUES (gen_random_uuid(), $1, 'PENDING', NOW())
     RETURNING *`,
    [user.user_id]
  );

  const request = requestRes.rows[0];

  
  await pool.query(
    `INSERT INTO landlorddocuments (id, requestId, docName, docPath)
     VALUES (gen_random_uuid(), $1, 'citizenship', $2)`,
    [request.id, file.filename]
  );

  return request;
};



export const getAllLandlordRequestsService = async () => {
  const res = await pool.query(`
    SELECT lr.id, lr.status, lr."createdAt",
           u.name, u.email,
           ld."docPath"
    FROM landlordrequests lr
    JOIN users u ON lr."userId" = u.user_id
    LEFT JOIN landlorddocuments ld ON ld."requestId" = lr.id
    ORDER BY lr."createdAt" DESC
  `);

  return res.rows;
};



export const approveLandlordRequestService = async (requestId: string) => {

  const res = await pool.query(`
    SELECT lr.id, u.email, u.name, u.user_id
    FROM landlordrequests lr
    JOIN users u ON lr."userId" = u.user_id
    WHERE lr.id=$1
  `, [requestId]);

  if (res.rows.length === 0) {
    throw new Error("Request not found");
  }

  const data = res.rows[0];


  await pool.query(
    "UPDATE users SET role='LANDLORD' WHERE user_id=$1",
    [data.user_id]
  );


  await pool.query(
    "UPDATE landlordrequests SET status='APPROVED' WHERE id=$1",
    [requestId]
  );


  await sendEmail(data.email, "APPROVED", data.name);

  return { message: "Approved successfully" };
};



export const rejectLandlordRequestService = async (requestId: string) => {
  const res = await pool.query(`
    SELECT lr.id, u.email, u.name
    FROM landlordrequests lr
    JOIN users u ON lr."userId" = u.user_id
    WHERE lr.id=$1
  `, [requestId]);

  if (res.rows.length === 0) {
    throw new Error("Request not found");
  }

  const data = res.rows[0];

  await pool.query(
    "UPDATE landlordrequests SET status='REJECTED' WHERE id=$1",
    [requestId]
  );

  await sendEmail(data.email, "REJECTED", data.name);

  return { message: "Rejected successfully" };
};