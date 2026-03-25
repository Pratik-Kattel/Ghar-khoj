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
export async function sendLandlordRequestNotificationToAdmin(
  adminEmail: string,
  tenantName: string,
  tenantEmail: string,
  submittedAt: string
) {
  const transporter = createTransporter();
  try {
    await transporter.sendMail({
      from: 'gharkhojrental@gmail.com',
      to: adminEmail,
      subject: '📋 New Landlord Request Submitted – Ghar Khoj',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e6e6e6; border-radius: 12px; overflow: hidden;">
 
          <div style="background: linear-gradient(135deg, #1a1a2e, #16213e); padding: 28px 30px; text-align: center;">
            <h1 style="color: white; margin: 0; font-size: 26px; letter-spacing: 1px;">Ghar Khoj</h1>
            <p style="color: rgba(255,255,255,0.6); margin: 6px 0 0; font-size: 13px;">Admin Notification</p>
          </div>
 
          <div style="padding: 32px 30px; background: #ffffff;">
            <div style="display: inline-block; background: #fef3c7; color: #d97706; padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 700; letter-spacing: 0.5px; margin-bottom: 20px;">
              ACTION REQUIRED
            </div>
 
            <h2 style="color: #1a1a2e; font-size: 20px; margin: 0 0 10px;">New Landlord Request</h2>
            <p style="color: #6b7280; font-size: 14px; line-height: 1.6; margin: 0 0 24px;">
              A tenant has submitted a request to become a landlord on Ghar Khoj. Please review their details and citizenship document in the admin dashboard.
            </p>
 
            <div style="background: #f8faff; border: 1px solid #e0e7ff; border-radius: 10px; padding: 20px; margin-bottom: 24px;">
              <table style="width: 100%; border-collapse: collapse;">
                <tr>
                  <td style="padding: 10px 0; color: #9ca3af; font-size: 13px; width: 35%;">👤 Applicant</td>
                  <td style="padding: 10px 0; color: #1a1a2e; font-weight: 700; font-size: 14px;">${tenantName}</td>
                </tr>
                <tr style="border-top: 1px solid #e5e7eb;">
                  <td style="padding: 10px 0; color: #9ca3af; font-size: 13px;">✉️ Email</td>
                  <td style="padding: 10px 0; color: #1a1a2e; font-weight: 600; font-size: 14px;">${tenantEmail}</td>
                </tr>
                <tr style="border-top: 1px solid #e5e7eb;">
                  <td style="padding: 10px 0; color: #9ca3af; font-size: 13px;">📅 Submitted</td>
                  <td style="padding: 10px 0; color: #1a1a2e; font-weight: 600; font-size: 14px;">${submittedAt}</td>
                </tr>
                <tr style="border-top: 1px solid #e5e7eb;">
                  <td style="padding: 10px 0; color: #9ca3af; font-size: 13px;">📄 Documents</td>
                  <td style="padding: 10px 0; color: #059669; font-weight: 600; font-size: 14px;">Citizenship uploaded ✓</td>
                </tr>
              </table>
            </div>
 
            <p style="color: #6b7280; font-size: 13px; line-height: 1.6;">
              Log in to the admin dashboard to view the submitted citizenship document and take action (Approve / Reject).
            </p>
 
            <hr style="border: none; border-top: 1px solid #f3f4f6; margin: 24px 0;"/>
            <p style="color: #9ca3af; font-size: 12px;">
              This is an automated notification from Ghar Khoj. Do not reply to this email.
            </p>
          </div>
 
          <div style="background: #f8f9fa; padding: 14px; text-align: center;">
            <p style="font-size: 12px; color: #9ca3af; margin: 0;">
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
 

 
export async function sendLandlordApprovalEmail(
  tenantEmail: string,
  tenantName: string
) {
  const transporter = createTransporter();
  try {
    await transporter.sendMail({
      from: 'gharkhojrental@gmail.com',
      to: tenantEmail,
      subject: '🎉 Congratulations! You are now a Landlord – Ghar Khoj',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e6e6e6; border-radius: 12px; overflow: hidden;">
 
          <div style="background: linear-gradient(135deg, #059669, #047857); padding: 28px 30px; text-align: center;">
            <h1 style="color: white; margin: 0; font-size: 26px; letter-spacing: 1px;">Ghar Khoj</h1>
            <p style="color: rgba(255,255,255,0.7); margin: 6px 0 0; font-size: 13px;">Account Update</p>
          </div>
 
          <div style="padding: 32px 30px; background: #ffffff;">
            <div style="text-align: center; margin-bottom: 24px;">
              <div style="display: inline-flex; align-items: center; justify-content: center; width: 64px; height: 64px; background: #d1fae5; border-radius: 50%; margin-bottom: 14px;">
                <span style="font-size: 32px;">🏠</span>
              </div>
              <h2 style="color: #1a1a2e; font-size: 22px; margin: 0 0 8px;">You're now a Landlord!</h2>
              <p style="color: #6b7280; font-size: 14px; margin: 0;">Your request has been approved by our admin team.</p>
            </div>
 
            <p style="color: #374151; font-size: 15px; line-height: 1.7;">
              Hi <strong>${tenantName}</strong>,
            </p>
            <p style="color: #374151; font-size: 14px; line-height: 1.7;">
              Great news! Your landlord request has been <strong style="color: #059669;">approved</strong>. Your account has been upgraded and you can now list properties on Ghar Khoj.
            </p>
 
            <div style="background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 10px; padding: 20px; margin: 24px 0;">
              <p style="color: #065f46; font-weight: 700; font-size: 14px; margin: 0 0 10px;">What you can do now:</p>
              <ul style="color: #047857; font-size: 13.5px; line-height: 2; margin: 0; padding-left: 20px;">
                <li>Upload and list your properties</li>
                <li>Set your own rental prices</li>
                <li>Manage tenant requests</li>
                <li>Track your rental earnings</li>
              </ul>
            </div>
 
            <p style="color: #6b7280; font-size: 13.5px; line-height: 1.6;">
              Simply log in to your Ghar Khoj account. Your role has been updated automatically — you'll see the landlord interface upon your next login.
            </p>
 
            <hr style="border: none; border-top: 1px solid #f3f4f6; margin: 24px 0;"/>
            <p style="color: #374151; font-size: 14px;">
              Welcome aboard,<br>
              <strong>Ghar Khoj Team</strong>
            </p>
          </div>
 
          <div style="background: #f8f9fa; padding: 14px; text-align: center;">
            <p style="font-size: 12px; color: #9ca3af; margin: 0;">
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
 
 
export async function sendLandlordRejectionEmail(
  tenantEmail: string,
  tenantName: string
) {
  const transporter = createTransporter();
  try {
    await transporter.sendMail({
      from: 'gharkhojrental@gmail.com',
      to: tenantEmail,
      subject: 'Update on Your Landlord Request – Ghar Khoj',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e6e6e6; border-radius: 12px; overflow: hidden;">
 
          <div style="background: linear-gradient(135deg, #1a1a2e, #16213e); padding: 28px 30px; text-align: center;">
            <h1 style="color: white; margin: 0; font-size: 26px; letter-spacing: 1px;">Ghar Khoj</h1>
            <p style="color: rgba(255,255,255,0.6); margin: 6px 0 0; font-size: 13px;">Account Update</p>
          </div>
 
          <div style="padding: 32px 30px; background: #ffffff;">
            <p style="color: #374151; font-size: 15px; line-height: 1.7;">
              Hi <strong>${tenantName}</strong>,
            </p>
            <p style="color: #374151; font-size: 14px; line-height: 1.7;">
              Thank you for your interest in becoming a landlord on Ghar Khoj. After reviewing your submitted documents, our admin team was unable to approve your request at this time.
            </p>
 
            <div style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px; padding: 20px; margin: 24px 0;">
              <p style="color: #991b1b; font-weight: 700; font-size: 14px; margin: 0 0 8px;">Request Status: Not Approved</p>
              <p style="color: #b91c1c; font-size: 13.5px; line-height: 1.6; margin: 0;">
                This may be due to unclear or invalid documentation. You are welcome to resubmit your request with a clearer copy of your citizenship document.
              </p>
            </div>
 
            <p style="color: #6b7280; font-size: 13.5px; line-height: 1.6;">
              Your account remains active as a tenant and all your existing data is intact. If you believe this was a mistake or need clarification, please reach out to our support team.
            </p>
 
            <div style="text-align: center; margin: 28px 0;">
              <a href="mailto:gharkhojrental@gmail.com"
                 style="background: #1a1a2e; color: white; padding: 12px 28px; border-radius: 25px; text-decoration: none; font-size: 14px; font-weight: bold;">
                Contact Support
              </a>
            </div>
 
            <hr style="border: none; border-top: 1px solid #f3f4f6; margin: 24px 0;"/>
            <p style="color: #374151; font-size: 14px;">
              Regards,<br>
              <strong>Ghar Khoj Team</strong>
            </p>
          </div>
 
          <div style="background: #f8f9fa; padding: 14px; text-align: center;">
            <p style="font-size: 12px; color: #9ca3af; margin: 0;">
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
 