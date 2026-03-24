const nodemailer = require('nodemailer');

function createTransporter() {
  return nodemailer.createTransport({
    secure: false,
    host: 'smtp.gmail.com',
    port: 587,
    auth: {
      user: 'gharkhojrental@gmail.com',
      pass: 'pozgilerciqtzroa'
    }
  });
}

export async function sendEmail(email: string, otp: string, userName: string) {
  const transporter = createTransporter();
  try {
    await transporter.sendMail({
      from: 'gharkhojrental@gmail.com',
      to: email,
      subject: 'Password Reset Request – Ghar Khoj Account',
      html: `
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
  } catch (error: any) {
    throw new Error(error.message);
  }
}

export async function sendRentalConfirmationToLandlord(
  landlordEmail: string,
  landlordName: string,
  tenantName: string,
  houseTitle: string,
  startDate: string,
  endDate: string,
  amount: number
) {
  const transporter = createTransporter();
  try {
    await transporter.sendMail({
      from: 'gharkhojrental@gmail.com',
      to: landlordEmail,
      subject: '🏠 Your Property Has Been Rented – Ghar Khoj',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e6e6e6; border-radius: 10px; overflow: hidden;">
          
          <div style="background: linear-gradient(135deg, #1a73e8, #0d47a1); padding: 30px; text-align: center;">
            <h1 style="color: white; margin: 0; font-size: 28px;">Ghar Khoj</h1>
            <p style="color: #c9d8f5; margin: 5px 0 0;">Property Rental Notification</p>
          </div>

          <div style="padding: 30px; background: #ffffff;">
            <p style="font-size: 16px; color: #2c3e50;">Hi <strong>${landlordName}</strong>,</p>
            <p style="font-size: 15px; color: #555;">
              Great news! Your property has been successfully rented. Here are the booking details:
            </p>

            <div style="background: #f0f4ff; border-left: 4px solid #1a73e8; border-radius: 8px; padding: 20px; margin: 25px 0;">
              <table style="width: 100%; border-collapse: collapse;">
                <tr>
                  <td style="padding: 10px 0; color: #888; font-size: 13px; width: 40%;">🏠 Property</td>
                  <td style="padding: 10px 0; color: #2c3e50; font-weight: bold; font-size: 14px;">${houseTitle}</td>
                </tr>
                <tr style="border-top: 1px solid #dde3f0;">
                  <td style="padding: 10px 0; color: #888; font-size: 13px;">👤 Rented By</td>
                  <td style="padding: 10px 0; color: #2c3e50; font-weight: bold; font-size: 14px;">${tenantName}</td>
                </tr>
                <tr style="border-top: 1px solid #dde3f0;">
                  <td style="padding: 10px 0; color: #888; font-size: 13px;">📅 Start Date</td>
                  <td style="padding: 10px 0; color: #2c3e50; font-weight: bold; font-size: 14px;">${startDate}</td>
                </tr>
                <tr style="border-top: 1px solid #dde3f0;">
                  <td style="padding: 10px 0; color: #888; font-size: 13px;">📅 End Date</td>
                  <td style="padding: 10px 0; color: #2c3e50; font-weight: bold; font-size: 14px;">${endDate}</td>
                </tr>
                <tr style="border-top: 1px solid #dde3f0;">
                  <td style="padding: 10px 0; color: #888; font-size: 13px;">💰 Total Amount</td>
                  <td style="padding: 10px 0; color: #1a73e8; font-weight: bold; font-size: 18px;">$${amount.toFixed(2)}</td>
                </tr>
              </table>
            </div>

            <p style="font-size: 14px; color: #555; line-height: 1.6;">
              The payment has been processed successfully. Please ensure the property is ready for the tenant by the start date.
            </p>

            <div style="text-align: center; margin: 30px 0;">
              <a href="mailto:gharkhojrental@gmail.com"
                 style="background: #1a73e8; color: white; padding: 12px 30px; border-radius: 25px; text-decoration: none; font-size: 14px; font-weight: bold;">
                Contact Support
              </a>
            </div>

            <hr style="border: none; border-top: 1px solid #eee; margin: 25px 0;"/>
            <p style="color: #555; font-size: 14px;">
              Thanks for listing with us!<br>
              <strong>Ghar Khoj Team</strong>
            </p>
          </div>

          <div style="background: #f8f9fa; padding: 15px; text-align: center;">
            <p style="font-size: 12px; color:#999; margin: 0;">
              © ${new Date().getFullYear()} Ghar Khoj. All rights reserved.
            </p>
          </div>

        </div>
      `
    });
  } catch (error: any) {
    throw new Error(error.message);
  }
}