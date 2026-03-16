import pool from "../config/db";
import cuid from "cuid";

export const addWishListService=async(email:string,house_id:string)=>{
    const checkExistance=await pool.query("Select * from wishlists where email=$1",[email]);
    if(checkExistance.rows.length>1){
        await pool.query("Delete * from wishlist where email=$1",[email]);
        return {message:"Wishlist removes",wishlisted:false}
    }
    const wishlist_id=cuid();
    const wishlist=await pool.query("Insert into wishlist (wishlist_id,user_email,house_id) values ($1,$2,$3) RETURNING *",[wishlist_id,email,house_id]);
    return {message:"Added to wishlist",wishlisted:true};
}
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
}