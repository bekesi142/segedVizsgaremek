import React from 'react';
import { Link } from 'react-router-dom';

const MainNavbar: React.FC = () => (
  <nav className="main-navbar">
    <ul className="nav-list">
      <li><Link to="/"><img src="/images/ikonok/home.png" alt="Home" className="nav-icon" /></Link></li>
      <li><Link to="/screenings"><img src="/images/ikonok/camera.png" alt="Screenings" className="nav-icon" /></Link></li>
      <li><Link to="/moviebase"><img src="/images/ikonok/clapperboard.png" alt="Moviebase" className="nav-icon" /></Link></li>
      <li><Link to="/snacks"><img src="/images/ikonok/popcorn.png" alt="Snacks" className="nav-icon" /></Link></li>
      <li><Link to="/special"><img src="/images/ikonok/cinema-screen.png" alt="Special" className="nav-icon" /></Link></li>
    </ul>
  </nav>
);

export default MainNavbar;