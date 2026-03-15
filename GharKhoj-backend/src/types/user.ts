export interface userData{
    name:string,
    email:string,
    password:string,
    otp:string,
    role?:UserRoles,

}

export enum UserRoles{
    LANDLORD='LANDLORD',
    TENANT='TENANT',
    ADMIN='ADMIN'
}

export interface UserInfo{
    id:string,
    email:string,
    role?:string
}