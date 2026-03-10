import { registerUserService, loginUserService } from "../service/auth_service";
import { Request, Response } from "express";
import { registerSchema } from "../validators/auth_validators";

export const registerUserController = async (req: Request, res: Response) => {
  try {
    const data = req.body;

    // Validate incoming request body using Zod schema
    const validatedData = registerSchema.safeParse(data);

    // If validation fails, return 400 Bad Request with detailed errors
    if (!validatedData.success) {
      return res.status(400).json({
        message: "Validation failed",
        errors: validatedData.error.issues,
      });
    }

    // Attempt to register the user after validation passes
    const user = await registerUserService(data);
    // Return 201 Created on successful user registration
    res.status(201).json({ message: "User created successfully", user });
  } catch (error:any) {
  res.status(400).json({
    message: error.message
  });
}
};

export const loginUserController = async (req: Request, res: Response) => {
  try {
    // Authenticate user with provided credentials
    const user = await loginUserService(req.body);
    // Return 200 OK on successful login
    res.status(200).json({ message: "Login successful", user }) ;
  } catch (error:any) {
        // res.status(500).json({ message: "Internal server error", error });
  res.status(400).json({
    message: error.message
  });
  }
};
