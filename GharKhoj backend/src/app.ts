import express from "express";
import {Request, Response} from "express";

import bodyParser from "body-parser";
const app=express();

app.use(bodyParser.json());

app.get("/",async(req:Request,res:Response)=>{
    res.set("API is Working")
});

export  default  app;


