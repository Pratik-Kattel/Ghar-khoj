import { JwtPayload } from "jsonwebtoken";


// This class declares 'express-serve-static-core' module in which Request type is defined
// Inside the class we have Request interface of the Express
// So, we are telling that Request object can optionally have the user property
declare module 'express-serve-static-core'{
    interface Request{
        user?:string | JwtPayload
    }
}