import pool from "../config/db";
import { userData } from "../types/user";

export const changeUsernameService=async(email:String,name:String)=>{
    const newName=await pool.query("Update users SET name=$1 where email=$2 RETURNING *",[name,email]);
    if(newName.rows.length===0){
        throw new Error("User not found")
    }
    return true;
}