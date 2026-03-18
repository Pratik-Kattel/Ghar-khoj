import { Request, Response } from "express";
import {uploadProfilePicService,getProfilePicService,} from "../service/upload_profilepic_service";

export const uploadProfilePicController = async (req: Request,res: Response) => {
  try {
    const { email } = req.body;
    const profilePic = req.file?.filename;

    if (!email) {
      return res.status(400).json({ message: "Email is required" });
    }
    if (!profilePic) {
      return res.status(400).json({ message: "Image is required" });
    }

    const result = await uploadProfilePicService(email, profilePic);
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getProfilePicController = async (req: Request, res: Response) => {
  try {
    const { email } = req.params;
    const result = await getProfilePicService(email);
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};