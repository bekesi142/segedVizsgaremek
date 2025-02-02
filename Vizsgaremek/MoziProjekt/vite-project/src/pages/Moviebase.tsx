// MovieBase.tsx
import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import MovieSlider from '../components/MovieSlider';
import MovieSearch from '../components/MovieSearch';
import MovieDetails from '../components/MovieDetails';
import '../styles/MovieSlider.css';
import '../types/movie'

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
  genre: string;
}

const Moviebase: React.FC = () => {
  const [movies, setMovies] = useState<Movie[]>([]);
  const [currentMovie, setCurrentMovie] = useState<Movie | null>(null);
  const [selectedMovie, setSelectedMovie] = useState<Movie | null>(null);

  useEffect(() => {
    fetch('/ideiglenesFilmek.json')
      .then(response => response.json())
      .then(data => {
        setMovies(data);
        setCurrentMovie(data[0]);
      })
      .catch(error => console.error('Error loading movies:', error));
  }, []);

  if (!currentMovie) return (
    <div className="loading-container">
      <div className="loading-spinner"></div>
    </div>
  );

  const handleMovieChange = (movie: Movie) => {
    setCurrentMovie(movie);
  };

  const handleMovieSelect = (movie: Movie) => {
    setSelectedMovie(movie);
  };

  return (
    <div className="moviebase-container">
      <AnimatePresence mode="wait">
        {selectedMovie ? (
          <MovieDetails movie={selectedMovie} />
        ) : (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <div className="featured-movie">
              <div className="featured-poster">
                <img 
                  src={currentMovie.PoszterKep} 
                  alt={currentMovie.Cim}
                />
              </div>

              <div className="movie-details">
                <h1>{currentMovie.Cim}</h1>
                <p className="release-year">{currentMovie.KiadasEve}</p>
                <p>{currentMovie.Tagline}</p>
                <button 
                  className="data-button"
                  onClick={() => setSelectedMovie(currentMovie)}
                >
                  Adatlap
                </button>
                {currentMovie.ElozetesUrl && (
                  <button className="data-button">
                    Előzetes
                  </button>
                )}
              </div>
            
              <MovieSlider 
              movies={movies}
              currentMovie={currentMovie}
              onMovieChange={handleMovieChange}
            />
            </div>

            

            <div className="movie-search-section">
              <MovieSearch 
                movies={movies} 
                onMovieSelect={handleMovieSelect}
              />
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default Moviebase;