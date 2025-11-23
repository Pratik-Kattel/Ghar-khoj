import z from 'zod';

 export const registerSchema=z.object({
    name:z.string().trim(),
    email:z.string().trim(),
    password:z.string().trim()
}).superRefine((data,ctx)=>{
     const { email, password } = data;

    // EMAIL VALIDATION FIRST
    if (!email.endsWith("@gmail.com")) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Please enter a valid email address",
        path: ["email"],
      });
      return;
    }

    //  PASSWORD VALIDATION
    if (password.length < 5) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Password must be greater than 5 digits",
        path: ["password"],
      });
      return;
    }

    if (!/[A-Z]/.test(password)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Password must include a capital letter",
        path: ["password"],
      });
      return;
    }

    if (!/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Password must include a special character",
        path: ["password"],
      });
      return;
    }

    if (!/[0-9]/.test(password)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Password must include a number",
        path: ["password"],
      });
      return;
    }
  });