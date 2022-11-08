import React, {useEffect, useState} from 'react';
import './App.css';
import Grid from "@mui/system/Unstable_Grid";
import {styled} from "@mui/system";
import {Duck, getDucks} from "./api";

const Item = styled('div')(({theme}) => ({
    backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
    border: '1px solid',
    borderColor: theme.palette.mode === 'dark' ? '#444d58' : '#ced7e0',
    padding: theme.spacing(1),
    borderRadius: '4px',
    textAlign: 'center',
    color: 'black'
}));


function App() {

    const [ducks, setDucks] = useState<Duck[]>([]);

    useEffect(() => {
        getDucks().then(d => setDucks(d));
        return () => {} ;
    }, [])

    return (
        <div className="App">
            <header className="App-header">
                <Grid container spacing={{xs: 2, md: 3}}
                      columns={{xs: 4, sm: 8, md: 12}}>
                    {Array.from(ducks).map((_, index) => (
                        <Grid xs={2} sm={4} key={index}>
                            <Item>{index + 1}</Item>
                        </Grid>
                    ))}
                </Grid>
            </header>
        </div>
    );
}

export default App;
