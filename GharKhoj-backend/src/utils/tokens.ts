import  jwt from "jsonwebtoken";
import {env} from '../config/env';
import { UserInfo } from "../types/user";

export const generate_access_token=(user:UserInfo)=>{
return jwt.sign({
    id:user.id,
    email:user.email,
    role:user.role
},
env.ACCESS_TOKEN_SECRET!,
{
    expiresIn:'30d' 
}
)
}