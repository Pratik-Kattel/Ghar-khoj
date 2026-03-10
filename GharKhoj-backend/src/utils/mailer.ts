const nodemailer=require('nodemailer');

export async function sendEmail(){
const transporter=await nodemailer.createTransport(
    {
    secure:true,
    host:'smtp.gmail.com',
    port:465,
    auth:{
        user:'gharkhojrental@gmail.com',
        pass:'pozgilerciqtzroa'
    }
});

const info=await transporter.sendMail({
    from:'gharkhojrental@gmail.com',
    to:'kattelpratik007@gmail.com',
    subject:'test',
    message:'Sending to test the stuff!!'
});
}
