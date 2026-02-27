import { registerUserController,loginUserController } from "../controllers/auth_controller";
import  express  from "express";

const router=express.Router();

router.post('/registerUser',registerUserController);
router.post('/loginUser',loginUserController);

export default router;