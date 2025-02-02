import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Home from './pages/Home';
import Screenings from './pages/Screenings';
import Moviebase from './pages/Moviebase';
import Snacks from './pages/Snacks';
import Special from './pages/Special';
import './styles.css';


const App: React.FC = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Home />} />
          <Route path="/screenings" element={<Screenings />} />
          <Route path="/moviebase" element={<Moviebase />} />
          <Route path="/Snacks" element={<Snacks />} />
          <Route path="/special" element={<Special />} />
        </Route>
      </Routes>
    </Router>
  );
};

export default App;