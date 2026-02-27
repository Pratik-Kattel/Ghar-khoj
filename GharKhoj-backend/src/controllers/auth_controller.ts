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

    // If user already exists or creation fails, return 409 Conflict
    if (!user) {
      return res.status(409).json({
        message: "User with this email already exixsts, please login to continue",
      });
    }

    // Return 201 Created on successful user registration
    res.status(201).json({ message: "User created sucessfully", user });
  } catch (error) {
    // Return 500 Internal Server Error for unexpected failures
    res.status(500).json({ error: `Internal error ocurred ${error}` });
  }
};

export const loginUserController = async (req: Request, res: Response) => {
  try {
    // Authenticate user with provided credentials
    const user = await loginUserService(req.body);

    // Invalid credentials should return 401 Unauthorized
    if (!user) {
      return res.status(401).json({ message: "Invalid credidentals" });
    }

    // Return 200 OK on successful login
    res.status(200).json({ message: "Login successful", user });
  } catch (error) {
    // Return 500 Internal Server Error for unexpected failures
    res.status(500).json({ message: "Internal server error", error });
  }
};
