import pool from "../config/db";
import cuid from "cuid";

export const addToWishListService = async (email: string, house_id: string) => {
  const checkExistence = await pool.query(
    "SELECT * FROM wishlists WHERE user_email = $1 AND house_id = $2",
    [email, house_id]
  );
  if (checkExistence.rows.length > 0) {
    await pool.query(
      "DELETE FROM wishlists WHERE user_email = $1 AND house_id = $2",
      [email, house_id]
    );
    return { message: "Removed from wishlist", wishlisted: false };
  }

  const wishlist_id = cuid();
  await pool.query(
    "INSERT INTO wishlists (wishlist_id, user_email, house_id) VALUES ($1, $2, $3) RETURNING *",
    [wishlist_id, email, house_id]
  );
  return { message: "Added to wishlist", wishlisted: true };
};

export const getWishlistService = async (userEmail: string) => {
  const query = `
    SELECT 
      w.wishlist_id,
      h.house_id,
      h.title,
      h.description,
      h.price,
      h.latitude,
      h.longitude,
      h.image_url,
      h.landlord_email
    FROM wishlists w
    JOIN houses h ON w.house_id = h.house_id
    WHERE w.user_email = $1
    ORDER BY h.created_at DESC
  `;
  const result = await pool.query(query, [userEmail]);
  return result.rows;
};

export const checkWishlistStatusService = async (
  userEmail: string,
  houseId: string
) => {
  const result = await pool.query(
    "SELECT wishlist_id FROM wishlists WHERE user_email = $1 AND house_id = $2",
    [userEmail, houseId]
  );
  return { wishlisted: result.rows.length > 0 };
};