import { Request, Response } from "express";
import { createAdminService } from "../service/create_admin_service";

export const createAdminController = async (req: Request, res: Response) => {
  try {
    const { name, email, password, secretKey } = req.body;

    if (!name || !email || !password || !secretKey) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const result = await createAdminService(name, email, password, secretKey);

    res.status(201).json({
      message: "Admin created successfully",
      data: result,
    });
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};