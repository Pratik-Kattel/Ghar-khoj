import pool from "../config/db";

export const getRecommendedHousesService = async () => {
  const query = `
    SELECT 
      h.house_id,
      h.title,
      h.description,
      h.price,
      h.latitude,
      h.longitude,
      h.image_url,
      h.landlord_email,
      ROUND(AVG(r.ratings)::numeric, 1) as average_rating,
      COUNT(r.review_id) as total_reviews
    FROM houses h
    LEFT JOIN reviews r ON h.house_id = r.house_id
    GROUP BY h.house_id
    HAVING AVG(r.ratings) >= 1
    ORDER BY average_rating DESC
  `;
  const result = await pool.query(query);
  return result.rows;
};