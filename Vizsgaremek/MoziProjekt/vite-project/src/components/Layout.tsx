import React from 'react';
import TopNavbar from './TopNavbar';
import MainNavbar from './MainNavbar';
import { Outlet } from 'react-router-dom';

const Layout: React.FC = () => {
  return (
    <div className="app-container">
      <TopNavbar />
      <MainNavbar />
      <main className="main-content">
        <Outlet />
      </main>
    </div>
  );
};

export default Layout;