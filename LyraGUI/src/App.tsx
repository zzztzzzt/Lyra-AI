import './App.css'
import MainColorArea from './MainColorArea';
import GradientArea from './GradientArea';

function App() {
  return (
    <div className=''>
      <div className='max-w-100 mx-auto font-prosto-one'>
        <div className='mt-6 text-center text-2xl text-transparent bg-clip-text bg-gradient-to-r from-primary to-secondary'>
          Lyra training system
        </div>
        <MainColorArea />
        <GradientArea />
      </div>
      <div>
        <div className='bg-black w-full h-10'></div>
      </div>
    </div>
  )
}

export default App
