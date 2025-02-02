// MovieSlider.tsx
import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import '../styles/MovieSlider.css';

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

interface MovieSliderProps {
  movies: Movie[];
  currentMovie: Movie;
  onMovieChange: (movie: Movie) => void;
}

const MovieSlider: React.FC<MovieSliderProps> = ({ movies, currentMovie, onMovieChange }) => {
  const [sliderValue, setSliderValue] = useState(0);
  const [visibleMovies, setVisibleMovies] = useState<Movie[]>([]);
  const VISIBLE_MOVIES_COUNT = 7;
  
  useEffect(() => {
    updateVisibleMovies(sliderValue);
  }, [sliderValue, movies]);

  const updateVisibleMovies = (currentIndex: number) => {
    const start = Math.max(0, currentIndex - Math.floor(VISIBLE_MOVIES_COUNT / 2));
    const end = Math.min(movies.length, start + VISIBLE_MOVIES_COUNT);
    const adjustedStart = Math.max(0, Math.min(start, movies.length - VISIBLE_MOVIES_COUNT));
    setVisibleMovies(movies.slice(adjustedStart, end));
  };

  const handleSliderChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const value = parseInt(event.target.value);
    setSliderValue(value);
    const selectedMovie = movies[value];
    onMovieChange(selectedMovie);
  };

  return (
    <div className="movie-slider-container">
      <div className="sliding-container">
        <div className="movie-thumbnails">
          <AnimatePresence mode="wait">
            {visibleMovies.map((movie) => (
              <motion.div
                key={movie.FilmId}
                className={`movie-thumbnail ${movie.FilmId === currentMovie.FilmId ? 'active' : ''}`}
                initial={{ opacity: 0, x: 100 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -100 }}
                transition={{ duration: 0.3 }}
                onClick={() => {
                  const movieIndex = movies.findIndex(m => m.FilmId === movie.FilmId);
                  setSliderValue(movieIndex);
                  onMovieChange(movie);
                }}
              >
                <img src={movie.PoszterKep} alt={movie.Cim} />
              </motion.div>
            ))}
          </AnimatePresence>
        </div>
      </div>

      <input
        type="range"
        min="0"
        max={movies.length - 1}
        value={sliderValue}
        onChange={handleSliderChange}
        className="custom-slider"
      />
    </div>
  );
};

export default MovieSlider;