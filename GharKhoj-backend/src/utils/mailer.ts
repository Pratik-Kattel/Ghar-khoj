import { userData } from "../types/user";

const nodemailer=require('nodemailer');

export async function sendEmail(email:String,otp:number,userName:String){
const transporter=await nodemailer.createTransport(
    {
    secure:false,
    host:'smtp.gmail.com',
    port:587,
    auth:{
        user:'gharkhojrental@gmail.com',
        pass:'pozgilerciqtzroa'
    }
});

try{
const info=await transporter.sendMail({
    from:'gharkhojrental@gmail.com',
    to:email,
    subject:'Password Reset Request – Ghar Khoj Account',
    html:`
    <div style="font-family: Arial, sans-serif; max-width:600px; margin:auto; border:1px solid #e6e6e6; padding:30px">

      <h2 style="color:#2c3e50;">Ghar Khoj</h2>

      <p>Hi <strong>${userName}</strong>,</p>

      <p>We received a request to reset the password for your <strong>Ghar Khoj</strong> account.</p>

      <p>Please use the following verification code:</p>

      <div style="font-size:32px; font-weight:bold; letter-spacing:5px; text-align:center; margin:20px 0; color:#2c3e50;">
        ${otp}
      </div>

      <p>This code will expire in <strong>5 minutes</strong>.</p>

      <hr style="margin:25px 0"/>

      <p style="color:#555;">
      <strong>Don't share this code with anyone.</strong><br>
      Ghar Khoj will never ask for your verification code.
      </p>

      <p style="color:#555;">
      If you didn't request a password reset, you can safely ignore this email.
      </p>

      <br>

      <p>Thanks,<br><strong>Ghar Khoj Security Team</strong></p>

      <hr style="margin-top:30px"/>

      <p style="font-size:12px; color:#999;">
      © ${new Date().getFullYear()} Ghar Khoj. All rights reserved.
      </p>

    </div>
    `
});
}
catch(error:any){
    throw new Error(error.message);
}
}
