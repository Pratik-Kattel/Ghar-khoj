import { registerUserController,loginUserController } from "../controllers/auth_controller";
import  express  from "express";
import { validateEmailController, validateOTPController } from "../controllers/change_password_controller";
import { sendEmail } from "../utils/mailer";

const router=express.Router();

router.post('/registerUser',registerUserController);
router.post('/loginUser',loginUserController);
router.post('/validateEmail',validateEmailController);
router.post('/validateOPT',validateOTPController);

export default router;