import React from 'react';
import ImageCarousel from '../components/ImageCarousel';
import TopTenFilms from '../components/TopTenFilms';

const Home: React.FC = () => (
  <>
    <div className="hero-section">
      <div className="video-background">
        <video autoPlay loop muted>
          <source src='../public/videos/hattervideo.mp4' type='video/mp4' />
        </video>
      </div>
      <div className="hero-content">
        <h1 className="hero-title">Phoenix Cinema</h1>
        <p className="hero-description">
        Step into the past, experience the magic. Bringing timeless classics back to the big screen, the way they were meant to be seen.
        </p>
        <div className="button-container">
          <button className="primary-button">Vetítések</button>
          <button className="primary-button">Szavazások</button>
        </div>
      </div>
    </div>
    
    <ImageCarousel />
    <TopTenFilms />
  </>
);

export default Home;