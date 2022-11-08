import axios from "axios";

export type Duck = {
    id: number,
    name: string,
    age: number,
    color: string
}

const instance = axios.create({
    baseURL: process.env.REACT_APP_API_URL,
    timeout: 1000
});

export const getDucks = async () => {
    let ducks = await instance.get<Duck[]>('/ducks');
    return ducks.data;
}

export const getDuck = async (id: number) => {
    let duck = await instance.get<Duck>(`/ducks/${id}`);
    return duck.data;
}

export const createDuck = async (name: string, age: number, color: string) => {
    let duck = await instance.post<Duck>('/ducks');
    return duck.data;
}

export const updateDuck = async (id: number) => {
    let duck = await instance.put<Duck>(`/ducks/${id}`);
    return duck.data;
}

export const deleteDuck = async (id: number) => {
    await instance.delete(`/ducks/${id}`);
}