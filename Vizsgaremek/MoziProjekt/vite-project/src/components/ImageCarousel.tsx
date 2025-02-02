import React, { useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { CarouselImage } from '../types';

const ImageCarousel: React.FC = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  
  const images: CarouselImage[] = [
    { id: 1, src: '/images/szeles.jpg', title: 'Western-week 01.06.-01.13.' },
    { id: 2, src: '/images/kozepes.jpg', title: 'Western-week 01.06.-01.13.' },
    { id: 3, src: '/images/magas.jpg', title: 'Western-week 01.06.-01.13.' },
  ];

  const goToPrevious = () => {
    setCurrentIndex((prev) => (prev === 0 ? images.length - 1 : prev - 1));
  };

  const goToNext = () => {
    setCurrentIndex((prev) => (prev === images.length - 1 ? 0 : prev + 1));
  };

  return (
    <div className="carousel-container">
      <div className="carousel-content">
        <button onClick={goToPrevious} className="carousel-button">
          <ChevronLeft size={24} />
        </button>
        
        <div className="carousel-image-container">
          <img 
            src={images[currentIndex].src} 
            alt={images[currentIndex].title}
            className="carousel-image"
          />
          <h3 className="carousel-title">
            {images[currentIndex].title}
          </h3>
        </div>

        <button onClick={goToNext} className="carousel-button">
          <ChevronRight size={24} />
        </button>
      </div>
      
      <div className="carousel-dots">
        {images.map((_, idx) => (
          <button
            key={idx}
            className={`carousel-dot ${idx === currentIndex ? 'active' : ''}`}
            onClick={() => setCurrentIndex(idx)}
          />
        ))}
      </div>
    </div>
  );
};

export default ImageCarousel;