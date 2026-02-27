import bcrypt from 'bcrypt';
/// This class will return the passowrd in the hashed format and compares the hashed password with the plain password.

// takes a password and return it in hash format
export const hashedPassword=async(password:string)=>{
    return bcrypt.hash(password,10);
}


// takes a plain password and compares it to the hashed one
export const comparePassword=async(password:string,hash:string)=>{
    return bcrypt.compare(password,hash);
}