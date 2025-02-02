import React from 'react';
import { User } from 'lucide-react';

const TopNavbar: React.FC = () => (
  <div className="top-navbar">
    <div>darkmode</div>
    <div className="navbar-title">Phoenix Cinema</div>
    <div><img src="public/images/ikonok/user.png" width= "32px" alt="" /></div>
  </div>
);

export default TopNavbar;