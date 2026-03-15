import pool from "../config/db";
import { userData } from "../types/user";


export const getUserDataService=async({email}:userData)=>{
    const result=await pool.query("SELECT name from users where email=$1",[email]);
    if(result.rows.length===0){
        throw new Error("User not found");
    }
    return result.rows[0].name;
}