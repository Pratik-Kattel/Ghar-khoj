import express from "express";
import {Request, Response} from "express";
import  {testConnection}  from './config/db';


import bodyParser from "body-parser";
const app=express();

app.use(bodyParser.json());

testConnection();

app.get("/",async(req:Request,res:Response)=>{
    res.send("API is Working")
});


export  default  app;


