import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';

interface Film {
  FilmId: number;
  Cim: string;
  PoszterKep: string;
}

const TopTenFilms: React.FC = () => {
  const [films, setFilms] = useState<Film[]>([]);

  // Function to shuffle array and get random 10 items
  const getRandomFilms = (allFilms: Film[]): Film[] => {
    // Fisher-Yates shuffle algorithm
    const shuffled = [...allFilms];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    // Return first 10 items
    return shuffled.slice(0, 10);
  };

  useEffect(() => {
    fetch('/ideiglenesFilmek.json')
      .then(response => response.json())
      .then(data => {
        // Set random 10 films from the loaded data
        const randomFilms = getRandomFilms(data);
        setFilms(randomFilms);
      })
      .catch(error => console.error('Error loading films:', error));
  }, []);

  return (
    <section className="top-ten-section">
      <div className="section-header">
        <hr className="header-line" />
        <h2 className="section-title">TOP 10 new films</h2>
        <hr className="header-line" />
      </div>
      
      <Link to="/screenings" className="booking-button">
        Foglalj helyet!
      </Link>

      <div className="films-grid">
        {films.map(film => (
          <div key={film.FilmId} className="film-card">
            <img 
              src={film.PoszterKep} 
              alt={film.Cim} 
              className="film-poster"
            />
          </div>
        ))}
      </div>
    </section>
  );
};

export default TopTenFilms;