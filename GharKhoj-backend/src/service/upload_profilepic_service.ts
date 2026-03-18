import pool from "../config/db";

export const uploadProfilePicService = async (email: string,profilePic: string) => {
  const user = await pool.query("SELECT user_id FROM users WHERE email = $1", [
    email,
  ]);
  if (user.rows.length === 0) throw new Error("User not found");

  await pool.query(
    "UPDATE users SET profile_pic = $1 WHERE email = $2",
    [profilePic, email]
  );
  return { message: "Profile picture updated successfully", profilePic };
};

export const getProfilePicService = async (email: string) => {
  const result = await pool.query(
    "SELECT profile_pic FROM users WHERE email = $1",
    [email]
  );
  if (result.rows.length === 0) throw new Error("User not found");
  return { profilePic: result.rows[0].profile_pic };
};