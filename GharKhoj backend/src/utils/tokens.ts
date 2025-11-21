import  jwt from "jsonwebtoken";
import {env} from '../config/env';

export const access_token=(user:any)=>{
return jwt.sign({
    id:user.id,
    email:user.email,
    role:user.role
},
env.ACCESS_TOKEN_SECRET!,
{
    expiresIn:'7d' 
}
)
}