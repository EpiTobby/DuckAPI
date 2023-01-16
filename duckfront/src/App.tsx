import React, {useEffect, useState} from 'react';
import './App.css';
import {styled} from "@mui/system";
import Grid from '@mui/material/Grid';
import Box from '@mui/material/Box';
import TextField from "@mui/material/TextField";
import Button from "@mui/material/Button";
import {createDuck, deleteDuck, Duck, getDucks, updateDuck} from "./api";
import {Container, MenuItem, Select} from "@mui/material";

const DuckItem = styled('div')(({theme}) => ({
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
    const [name, setName] = useState<string>('');
    const [color, setColor] = useState<string>('yellow');
    const [age, setAge] = useState<string>('1');
    const [id, setId] = useState<number>(0);
    const [isEditing, setIsEditing] = useState<boolean>(false);

    useEffect(() => {
        getDucks()
          .then(d => setDucks(d.reverse()))
          .catch(e => console.error(e));
        return () => {} ;
    }, []);

    const clearInputs = () => {
        setName('');
        setColor('yellow');
        setAge('1');
        setId(0);
        setIsEditing(false);
    }

    const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        if (name === '' || age === '' || color === '')
            return;
        let ageNumber = Number(age);
        if (isNaN(ageNumber)) {
            ageNumber = 1;
        }
        createDuck(name, ageNumber, color)
          .then(d => {
              setDucks([d, ...ducks]);
              clearInputs();
          })
          .catch(e => console.error(e));
    }

    const handleSubmitEdit = (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        if (name === '' || age === '' || color === '')
            return;
        let ageNumber = Number(age);
        if (isNaN(ageNumber)) {
            ageNumber = 1;
        }
        updateDuck(id, name, ageNumber, color)
          .then(d => {
              setDucks(ducks => ducks.map(duck => duck.id === d.id ? d : duck));
              clearInputs();
          })
          .catch(e => console.error(e));
    }

    const handleEdit = (duck: Duck) => {
        setIsEditing(true);
        setId(duck.id);
        setName(duck.name);
        setColor(duck.color);
        setAge(duck.age.toString());
    }

    const handleDelete = (id: number) => {
        deleteDuck(id)
          .then(() => {
              setDucks(ducks.filter(d => d.id !== id));
              clearInputs();
          })
          .catch(e => console.error(e));
    }

    return (
      <div className="App">
          <main>
              <Container component="section" maxWidth="xs">
                  <h3>{process.env.REACT_APP_API_URL}</h3>
                  <Box
                    sx={{
                        marginTop: 8,
                        display: 'flex',
                        flexDirection: 'column',
                        alignItems: 'center',
                    }}
                  >
                      <h2>{ isEditing ? "Edit duck" : "Add a duck"}</h2>
                      <Box component="form" noValidate onSubmit={isEditing ? handleSubmitEdit : handleSubmit}>
                          <Grid container spacing={2}>
                              <Grid item xs={12}>
                                  <TextField
                                    autoComplete="MyDuck"
                                    name="Duck Name"
                                    required
                                    fullWidth
                                    id="duckName"
                                    label="Duck Name"
                                    autoFocus
                                    value={name}
                                    onChange={(e) => setName(e.target.value)}
                                  />
                              </Grid>
                              <Grid item xs={12} sm={6}>
                                  <TextField
                                    required
                                    fullWidth
                                    id="age"
                                    label="Duck Age"
                                    name="duckAge"
                                    autoComplete="1"
                                    type="number"
                                    value={age}
                                    onChange={(e) => setAge(e.target.value)}
                                  />
                              </Grid>
                              <Grid item xs={12} sm={6}>
                                  <Select
                                    value={color}
                                    onChange={(e) => setColor(e.target.value as string)}
                                  >
                                      <MenuItem value={"yellow"}>Yellow</MenuItem>
                                      <MenuItem value={"red"}>Red</MenuItem>
                                      <MenuItem value={"blue"}>Blue</MenuItem>
                                  </Select>
                              </Grid>
                          </Grid>
                          <Button
                            type="submit"
                            fullWidth
                            variant="contained"
                            sx={{ mt: 3, mb: 2 }}
                          >
                              {isEditing ? "Edit Duck" : "Add Duck"}
                          </Button>
                      </Box>
                  </Box>
              </Container>
              <Container component="section" maxWidth="xs">
                  <h2>All Ducks</h2>
                  <Grid container spacing={{xs: 2, md: 3}} maxWidth={"xs"}
                        columns={{xs: 4, sm: 8, md: 12}}>
                      {Array.from(ducks).map((duck, index) => (
                        <Grid xs={2} sm={4} key={index} item>
                            <DuckItem>
                                <h3 style={{color: duck.color}}>{duck.name}</h3>
                                <p>Age: {duck.age}</p>
                                <Button variant="text" onClick={() => handleEdit(duck)}>Edit</Button>
                                <Button variant="text" color="error" onClick={() => handleDelete(duck.id)}>Delete</Button>
                            </DuckItem>
                        </Grid>
                      ))}
                  </Grid>
              </Container>
          </main>
      </div>
    );
}

export default App;
