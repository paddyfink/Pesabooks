import { Button, Stack, Text, useColorModeValue } from '@chakra-ui/react';
import React from 'react';
import { Outlet, useMatch, useNavigate, useResolvedPath } from 'react-router-dom';

const Links = [
  { title: 'Overview', uri: './' },
  { title: 'Administrators', uri: './admins' },
  { title: 'Categories', uri: './categories' },
];

const NavLink = ({ title, link }: { title: string; link: string }) => {
  const bgActiveButton = useColorModeValue('#fff', 'gray.700');
  const textColor = useColorModeValue('gray.700', 'white');
  const navigate = useNavigate();

  let resolved = useResolvedPath(link);
  let match = useMatch({ path: resolved.pathname, end: true });

  return (
    <Button
      borderRadius="12px"
      boxShadow={!!match ? '0px 2px 5.5px rgba(0, 0, 0, 0.06)' : 'none'}
      bg={!!match ? bgActiveButton : 'transparent'}
      transition="all .5s ease"
      w={{ sm: '100%', lg: '135px' }}
      h="35px"
      _hover={{}}
      _focus={{ boxShadow: '0px 2px 5.5px rgba(0, 0, 0, 0.06)' }}
      _active={{
        boxShadow: !!match ? '0px 2px 5.5px rgba(0, 0, 0, 0.06)' : 'none',
      }}
      onClick={() => navigate(`${link}`)}
    >
      <Text color={textColor} fontSize="xs" fontWeight="bold">
        {title}
      </Text>
    </Button>
  );
};

export const SettingsPage = () => {
  return (
    <>
      <Stack
        direction={{ sm: 'column', lg: 'row' }}
        spacing={{ sm: '8px', lg: '38px' }}
        w={{ sm: '100%', lg: '' }}
        mb="24px"
      >
        {Links.map((link, index) => (
          <NavLink key={index} title={link.title} link={link.uri} />
        ))}
      </Stack>
      {<Outlet />}
    </>
  );
};
