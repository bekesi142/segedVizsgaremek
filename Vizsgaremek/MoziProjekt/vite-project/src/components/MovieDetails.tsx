
// MovieDetails.tsx
import React, { useState } from 'react';
import '../styles/MovieDetails.css';

interface Movie {
  FilmId: number;
  ImdbId: number;
  Cim: string;
  Hossz: number;
  Bemutatas: string;
  Tagline: string;
  ElozetesUrl: string;
  KiadasEve: number;
  PoszterKep: string;
  HatterKep: string | null;
  ImdbErtekeles: number;
  Kulcsszavak: string;
  Rendezo: string;
  Szineszek: string;
}

interface MovieDetailsProps {
  movie: Movie;
}

const MovieDetails: React.FC<MovieDetailsProps> = ({ movie }) => {
  const [showCast, setShowCast] = useState(false);

  const handleTrailerClick = () => {
    window.open(movie.ElozetesUrl, '_blank');
  };

  const handleCastClick = () => {
    setShowCast(true);
  };

  const handleCloseCast = () => {
    setShowCast(false);
  };

  const genres = movie.Kulcsszavak.split('|').slice(0, 3).join(' | ');

  return (
    <div className="movie-details-container">
      <div className="movie-header">
        <h1>{movie.Cim}</h1>
        <p className="tagline">{movie.Tagline}</p>
        <p className="director">Directed by: {movie.Rendezo}</p>
        <p className="description">{movie.Bemutatas}</p>
        <p className="release-year">{movie.KiadasEve}</p>
        <p className="duration">{movie.Hossz} minutes</p>
        <p className="genres">{genres}</p>
      </div>
      <div className="movie-poster">
        <img src={movie.PoszterKep} alt={movie.Cim} />
      </div>
      <div className="movie-background">
        {movie.HatterKep && <img src={movie.HatterKep} alt={`${movie.Cim} background`} />}
      </div>
      <div className="movie-rating">
        <p>IMDb Rating: {movie.ImdbErtekeles}/10</p>
      </div>
      <div className="movie-actions">
        <button onClick={handleTrailerClick}>Watch Trailer</button>
        <button onClick={handleCastClick}>Cast</button>
      </div>
      {showCast && (
        <div className="cast-modal">
          <div className="cast-modal-content">
            <h2>Cast</h2>
            <ul>
              {movie.Szineszek.split('|').map((actor, index) => (
                <li key={index}>{actor}</li>
              ))}
            </ul>
            <button onClick={handleCloseCast}>Close</button>
          </div>
        </div>
      )}
    </div>
  );
};

export default MovieDetails;