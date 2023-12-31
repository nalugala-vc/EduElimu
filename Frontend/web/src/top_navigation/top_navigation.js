import React from 'react';
import {BiMessageRoundedDots,BiBell} from 'react-icons/bi';
import './top_navigation.css';
import { useAuth } from '../context/AuthContext';
import { Link, useNavigate } from 'react-router-dom';
import { useUserContext } from '../context/UserContext';

function TopNavigation(){
    const {currentUser} = useAuth();
    const navigate = useNavigate();
    const {user} = useUserContext();

    function login(){
        navigate('/login');
    }

    const displaypic = user && user.profile_image ? `http://127.0.0.1:8000/storage/${user.profile_image}`:`${process.env.PUBLIC_URL}/assets/eduelimu.png`;
    
    return <div className='top-nav'>
        <div>
            <input id='search'
                type="text"
                placeholder="&#x1F50D; Search..."
            />
        </div>
        <div id='right'>
            {currentUser? <> 

           <Link to={"/profile"}>
           <div className='profile-container'>
                <div className='img'>
                    <img src={displaypic} alt='name' />
                </div>
                <div className='profile-info'>
                    <h5>{currentUser && currentUser.email|| currentUser.phoneNumber}</h5>
                    <p>Nairobi,Kenya</p>
                </div>
            </div>
           </Link></> :<button onClick={login}>Log in</button> }
            
            {/* <BiBell className='top-icons'/>
            <BiMessageRoundedDots  className='top-icons'/>

            <div className='profile-container'>
                <div className='img'>
                    <img src="https://res.cloudinary.com/diqqf3eq2/image/upload/v1595959131/person-2_ipcjws.jpg" alt='name' />
                </div>
                <div className='profile-info'>
                    <h5>{currentUser && currentUser.email}</h5>
                    <p>{}</p>
                </div>
            </div> */}
        </div>
    </div>
}
export default TopNavigation;