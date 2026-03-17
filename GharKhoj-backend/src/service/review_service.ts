import pool from "../config/db";
import cuid from "cuid";

export const addReviewService = async (
  houseId: string,
  tenantEmail: string,
  rating: number,
  comment: string
) => {
  const existing = await pool.query(
    "SELECT review_id FROM reviews WHERE house_id = $1 AND tenant_email = $2",
    [houseId, tenantEmail]
  );

  if (existing.rows.length > 0) {
    
    await pool.query(
      "UPDATE reviews SET ratings = $1, comment = $2 WHERE house_id = $3 AND tenant_email = $4",
      [rating, comment, houseId, tenantEmail]
    );
    return { message: "Review updated successfully" };
  }

 
  const reviewId = cuid();
  await pool.query(
    "INSERT INTO reviews (review_id, house_id, tenant_email, ratings, comment) VALUES ($1, $2, $3, $4, $5)",
    [reviewId, houseId, tenantEmail, rating, comment]
  );
  return { message: "Review added successfully" };
};

export const getReviewsService = async (houseId: string) => {
  const query = `
    SELECT 
      r.review_id,
      r.ratings,
      r.comment,
      r.created_at,
      u.name as tenant_name
    FROM reviews r
    JOIN users u ON r.tenant_email = u.email
    WHERE r.house_id = $1
    ORDER BY r.created_at DESC
  `;
  const result = await pool.query(query, [houseId]);
  return result.rows;
};

export const getAverageRatingService = async (houseId: string) => {
  const result = await pool.query(
    "SELECT ROUND(AVG(ratings)::numeric, 1) as average, COUNT(*) as total FROM reviews WHERE house_id = $1",
    [houseId]
  );
  return {
    average: parseFloat(result.rows[0].average) || 0.0,
    total: parseInt(result.rows[0].total) || 0,
  };
};