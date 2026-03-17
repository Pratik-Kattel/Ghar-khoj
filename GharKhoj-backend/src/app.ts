import express from "express";
import {Request, Response} from "express";
import  {testConnection}  from './config/db';
import userRoutes from './routes/user_routes';
import path from "path";


import bodyParser from "body-parser";
const app=express();

app.use(bodyParser.json());
app.use("/uploads", express.static(path.join(__dirname, "../src/utils/uploads")));
app.use("/api/gharKhoj",userRoutes);

testConnection();

app.get("/",async(req:Request,res:Response)=>{
    res.send("API is Working")
});


export  default  app;


