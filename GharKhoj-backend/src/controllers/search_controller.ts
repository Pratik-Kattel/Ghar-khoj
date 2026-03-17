import { Request, Response } from "express";
import { searchHousesService } from "../service/search_service";

export const searchHousesController = async (req: Request, res: Response) => {
  try {
    const { query, sortBy } = req.query;
    if (!query || typeof query !== "string") {
      return res.status(400).json({ message: "query is required" });
    }
    const houses = await searchHousesService(
      query,
      typeof sortBy === "string" ? sortBy : "none"
    );
    res.status(200).json({ houses });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};