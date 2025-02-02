// MovieSearch.tsx
import React, { useState, useEffect } from 'react';
import '../styles/MovieSearch.css';
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

interface MovieSearchProps {
  movies: Movie[];
  onMovieSelect: (movie: Movie) => void;
}

const MovieSearch: React.FC<MovieSearchProps> = ({ movies, onMovieSelect }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState<'Cim' | 'KiadasEve' | 'Hossz'>('Cim');
  const [showFilterModal, setShowFilterModal] = useState(false);
  const [selectedGenres, setSelectedGenres] = useState<string[]>([]);
  
  // Extract unique genres from all movies
  const allGenres = [...new Set(movies.flatMap(movie => movie.genre.split('|')))];

  // Handle genre selection
  const toggleGenre = (genre: string) => {
    setSelectedGenres(prev => 
      prev.includes(genre) 
        ? prev.filter(g => g !== genre)
        : [...prev, genre]
    );
  };

  // Filter movies based on search term and selected genres
  const filteredMovies = movies.filter(movie => {
    const searchMatch = 
      movie.Cim.toLowerCase().includes(searchTerm.toLowerCase()) ||
      movie.Rendezo.toLowerCase().includes(searchTerm.toLowerCase()) ||
      movie.Kulcsszavak.toLowerCase().includes(searchTerm.toLowerCase());
    
    const genreMatch = 
      selectedGenres.length === 0 || 
      selectedGenres.every(genre => movie.genre.includes(genre));
    
    return searchMatch && genreMatch;
  });

  // Sort filtered movies
  const sortedMovies = [...filteredMovies].sort((a, b) => {
    switch (sortBy) {
      case 'Cim':
        return a.Cim.localeCompare(b.Cim);
      case 'KiadasEve':
        return b.KiadasEve - a.KiadasEve;
      case 'Hossz':
        return a.Hossz - b.Hossz;
      default:
        return 0;
    }
  });

  return (
    <div className="movie-search-container">
      <div className="search-controls">
        <input
          type="text"
          placeholder="Keresés cím, rendező vagy kulcsszavak alapján..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="search-input"
        />
        
        <select 
          className="sort-select"
          value={sortBy}
          onChange={(e) => setSortBy(e.target.value as 'Cim' | 'KiadasEve' | 'Hossz')}
        >
          <option value="Cim">ABC szerint</option>
          <option value="KiadasEve">Megjelenés éve szerint</option>
          <option value="Hossz">Hossz szerint</option>
        </select>

        <button 
          className="filter-button"
          onClick={() => setShowFilterModal(true)}
        >
          Szűrés
        </button>
      </div>

      {showFilterModal && (
        <div className="filter-modal-overlay">
          <div className="filter-modal">
            <h3>Szűrés műfaj szerint</h3>
            <div className="genre-grid">
              {allGenres.map(genre => (
                <label key={genre} className="genre-checkbox">
                  <input
                    type="checkbox"
                    checked={selectedGenres.includes(genre)}
                    onChange={() => toggleGenre(genre)}
                  />
                  <span>{genre}</span>
                </label>
              ))}
            </div>
            <div className="modal-buttons">
              <button 
                onClick={() => setShowFilterModal(false)}
                className="modal-button"
              >
                Bezárás
              </button>
              <button 
                onClick={() => {
                  setSelectedGenres([]);
                  setShowFilterModal(false);
                }}
                className="modal-button"
              >
                Szűrők törlése
              </button>
            </div>
          </div>
        </div>
      )}

      <div className="movie-grid">
        {sortedMovies.map(movie => (
          <div
            key={movie.FilmId}
            className="movie-card"
            onClick={() => onMovieSelect(movie)}
          >
            <img src={movie.PoszterKep} alt={movie.Cim} className="movie-poster" />
            <div className="movie-info">
              <h3>{movie.Cim}</h3>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default MovieSearch;