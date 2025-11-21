export interface userData{
    name:string,
    email:string,
    password:string,
    role?:UserRoles,

}

export enum UserRoles{
    LANDLORD='landlord',
    TENANT='tenant',
    ADMIN='admin'
}