// src/types/movie.ts
export interface Movie {
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
  
  // For components that only need basic movie data
  export interface MoviePreview extends Pick<Movie, 'FilmId' | 'Cim' | 'KiadasEve' | 'PoszterKep'> {}