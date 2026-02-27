import 'dotenv/config';

// This file will use all the variables inside the .env file
export const env={
    PORT:process.env.PORT || 3000,
    DATABASE_URL:process.env.DATABASE_URL!,
    ACCESS_TOKEN_SECRET:process.env.ACCESS_TOKEN_SECRET! || "",

};


