import pool from "../config/db";
import { userData } from "../types/user";
import logger from "../config/logger";
import { hashedPassword } from "../utils/hash_password";
import {UserRoles} from '../types/user';

export const registerUserService=async({name,email,password,role}:userData)=>{
    const existingUser=await pool.query("SELECT * FROM Users where email= $1",[email])
    if(existingUser){
        logger.error("User with this email already exists, please login to continue");
        return;
    }
    const hash= hashedPassword(password);
    const newUser= await pool.query(
        "INSERT INTO USERS (name,email,passwordHash,role) RETURNING *",[name,email,password,role]
    );
    return newUser.rows[0];

}