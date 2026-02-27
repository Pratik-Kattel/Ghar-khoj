export interface userData{
    name:string,
    email:string,
    password:string,
    role?:UserRoles,

}

export enum UserRoles{
    LANDLORD='LANDLORD',
    TENANT='TENANT',
    ADMIN='ADMIN'
}

export interface UserInfo{
    id:String,
    email:String,
    role?:String
}